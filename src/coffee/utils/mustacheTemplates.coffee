$.extend
	mustacheTemplates :
		navigator_ancestors : "{{#mus_ancestry}}<a href='/{{mus_url}}' onclick='{{mus_onclick}}'}>{{title}}</a> > {{/mus_ancestry}}"
		navigator_current_section : '<a href="/{{mus_url}}" onclick="return false">{{title}}</a>'
		searchresults : '{{#searchresults}}<a href="/{{title}}" onclick="{{mus_onclick}}">{{title}}</a> <br> {{/searchresults}}'
		defaultTableView : '
        <table cellpadding="0" cellspacing="0" border="0" class="display">
            <thead>
                <tr>
                    <th>תקציב</th>
                    <th>שנה</th>
                    <th>מזהה</th>
                </tr>
            </thead>
            <tbody>
                <tr class="odd gradeX">
                    <td>1234.0</td>
                    <td>1948</td>
                    <td>0020</td>
                </tr>
            </tbody>
        </table>
        '
