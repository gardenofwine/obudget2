#CR: So this is a controller manager, but it actually contains lots of view related functionality. Better separate it to a layout controller which takes care of all the other widgets on the screen (i.e. not visualizations).

$.extend
	Visualization:
		visibleCont : =>
			_visCont;
		controllers : =>
			if not @_controllers
				@_controllers = []
			@_controllers
		addController : (cont,$vizContents) ->
			# Yack. There must be a better way to access controllers
			controllers = $.Visualization.controllers()
			controllers.push new cont $vizContents

			return
		initControllers : ($visButtons)->
			model = $.Model.get()

			# set up the model listener
			mlist = $.ModelListener
				loadItem : (data)->

					# set navigation title
					mus_data =
						title: data.title
						vid: data.virtual_id
					# titleToOnClick attaches a history pushState action when clicking on an item
					$.extend data, {mus_url: $.titleToUrl mus_data}, {mus_onclick : $.titleToOnClick mus_data}
					if data.ancestry?
						data.mus_ancestry = data.ancestry.slice(0).reverse()
						$.each data.mus_ancestry, (index, value)->
							mus_value =
								title: value.title
								vid: value.virtual_id
							$.extend value, {mus_url: $.titleToUrl mus_value}, {mus_onclick: $.titleToOnClick mus_value}
							return

					console.log "** loadItem - set navigation."
					console.log "** Data Ancestry: ", data.ancestry 

					# render the ancestors of the current slug => heading, top right, "<B<A"
					($ "#navigator #ancestors").html Mustache.to_html $.mustacheTemplates.navigator_ancestors, data
					# renders the leaf section heading, top right (the x in "X<B<A")
					($ "#navigator #current_section").html Mustache.to_html $.mustacheTemplates.navigator_current_section, data

					# Set the Disqus comments plugin for the current graph
					#$("#fbCommentsPlaceholder").html '<div class="fb-comments" data-href="http://obudget2.cloudfoundry.com/index.html#' + data.virtual_id + '" data-num-posts="2" data-width="470"></div>'

                                        #CR: The commenting mechanism should have been separated using a generic interface.
					if DISQUS?
						DISQUS.reset
							reload: true,
							config: ()->
								# refactor magic word 'disqus'
								window.disqus_identifier = this.page.identifier = "disqus" + data.virtual_id;
								window.disqus_url = this.page.url = "http://obudget2.cloudfoundry.com/index.html#!" + data.virtual_id;
								return
					return

			model.addListener mlist
			
			# get first data
			model.getData History.getState().data.vid

			# Set up the History state change handler
			# whenever the history state changes, 
			# make the model inititiate a data load 
			# which will also wakeup listeners
			History.Adapter.bind window, 'statechange', ->
				console.log "state changed!"
				if not History.getState().data.vid?
					console.log "** no data vid in state"
					return

				model.getData History.getState().data.vid
				return

			# loop over all viz controllers
			# for each generate a button, which when clicked invokes
			# the showcontroller function on the corresponding controller
			
			# then add all the button to to div given to us by the caller 
			for cont in $.Visualization.controllers()
				do (cont) ->
					###
					add button to select the visualization represented by the controller
					###
					#button = $("<input type='button' class='vis-button' value='Show " + cont.id + "' id='vis-" + cont.id + "-button'/>")

					# these buttons use href="#" as per bootstrap guidelines.
					# see http://twitter.github.com/bootstrap/javascript.html#dropdowns
					button = $("<li><a href='#" + cont.id + "'>" + cont.id + "</a></li>")
					button.click  ->
						$.Visualization.showController cont
						return

					$visButtons.append button
					return
					
			# activate all dropdown menus , bootstrap idiom
			$('.dropdown-toggle').dropdown()

			###
			Add the Embed button
			###
			($ "#embed-widget").html 'Embed Code: <textarea></textarea>'

			###
			Year Span radio button selector
			###
#			$("#multiYearForm").change (event)->
#				val = ($ ':checked',event.currentTarget).val()
#				$.Visualization.visibleCont().setMultiYear (val == "true")
#				return

			return

		showController : (cont) =>
			# hide previous visible controller if any
			if (@_visCont? and @_visCont != cont)
				@_visCont.setVisible(false);
			# remember tha new active controller and make it visible
			@_visCont = cont
			cont.setVisible(true)

			# set embedding text
			($ "#embed-widget textarea").html '&lt;iframe width="560" height="315" src="VizEmbed.html?' + cont.id + '" &gt;&lt;/iframe&gt;'

			return
			
		# not used?
		controllerByType : (type) =>
			controllers = $.Visualization.controllers()
			cont = null
			$.each controllers,(index,value)->
				if value.id == type
					cont = value
					return
			return cont


