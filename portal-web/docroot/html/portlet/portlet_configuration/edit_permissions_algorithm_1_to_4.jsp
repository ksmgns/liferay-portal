<%
/**
 * Copyright (c) 2000-2009 Liferay, Inc. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<%@ include file="/html/portlet/portlet_configuration/init.jsp" %>

<%
String tabs2 = ParamUtil.getString(request, "tabs2", "users");
String tabs3 = ParamUtil.getString(request, "tabs3", "current");

String cur = ParamUtil.getString(request, "cur");

String redirect = ParamUtil.getString(request, "redirect");
String returnToFullPageURL = ParamUtil.getString(request, "returnToFullPageURL");

String portletResource = ParamUtil.getString(request, "portletResource");

String modelResource = ParamUtil.getString(request, "modelResource");
String modelResourceDescription = ParamUtil.getString(request, "modelResourceDescription");
String modelResourceName = ResourceActionsUtil.getModelResource(pageContext, modelResource);

String resourcePrimKey = ParamUtil.getString(request, "resourcePrimKey");

if (Validator.isNull(resourcePrimKey)) {
	throw new ResourcePrimKeyException();
}

String selResource = modelResource;
String selResourceDescription = modelResourceDescription;
String selResourceName = modelResourceName;

if (Validator.isNull(modelResource)) {
	PortletURL portletURL = new PortletURLImpl(request, portletResource, plid, PortletRequest.RENDER_PHASE);

	portletURL.setWindowState(WindowState.NORMAL);
	portletURL.setPortletMode(PortletMode.VIEW);

	redirect = portletURL.toString();

	Portlet portlet = PortletLocalServiceUtil.getPortletById(company.getCompanyId(), portletResource);

	selResource = portlet.getRootPortletId();
	selResourceDescription = PortalUtil.getPortletTitle(portlet, application, locale);
	selResourceName = LanguageUtil.get(pageContext, "portlet");
}

Group group = layout.getGroup();
long groupId = layout.getGroupId();

Layout selLayout = null;

if (modelResource.equals(Layout.class.getName())) {
	selLayout = LayoutLocalServiceUtil.getLayout(GetterUtil.getLong(resourcePrimKey));

	group = selLayout.getGroup();
	groupId = group.getGroupId();
}

Resource resource = null;

try {
	resource = ResourceLocalServiceUtil.getResource(company.getCompanyId(), selResource, ResourceConstants.SCOPE_INDIVIDUAL, resourcePrimKey);
}
catch (NoSuchResourceException nsre) {
	boolean portletActions = Validator.isNull(modelResource);

	ResourceLocalServiceUtil.addResources(company.getCompanyId(), groupId, 0, selResource, resourcePrimKey, portletActions, true, true);

	resource = ResourceLocalServiceUtil.getResource(company.getCompanyId(), selResource, ResourceConstants.SCOPE_INDIVIDUAL, resourcePrimKey);
}

PortletURL portletURL = renderResponse.createRenderURL();

portletURL.setParameter("struts_action", "/portlet_configuration/edit_permissions");
portletURL.setParameter("tabs2", tabs2);
portletURL.setParameter("tabs3", tabs3);
portletURL.setParameter("redirect", redirect);
portletURL.setParameter("returnToFullPageURL", returnToFullPageURL);
portletURL.setParameter("portletResource", portletResource);
portletURL.setParameter("modelResource", modelResource);
portletURL.setParameter("modelResourceDescription", modelResourceDescription);
portletURL.setParameter("resourcePrimKey", resourcePrimKey);

request.setAttribute("edit_permissions_algorithm_1_to_4.jsp-tabs2", tabs2);
request.setAttribute("edit_permissions_algorithm_1_to_4.jsp-tabs3", tabs3);

request.setAttribute("edit_permissions_algorithm_1_to_4.jsp-portletResource", portletResource);
request.setAttribute("edit_permissions_algorithm_1_to_4.jsp-modelResource", modelResource);
request.setAttribute("edit_permissions_algorithm_1_to_4.jsp-group", group);
request.setAttribute("edit_permissions_algorithm_1_to_4.jsp-groupId", groupId);
request.setAttribute("edit_permissions_algorithm_1_to_4.jsp-resource", resource);

request.setAttribute("edit_permissions_algorithm_1_to_4.jsp-portletURL", portletURL);
%>

<script type="text/javascript">
	function <portlet:namespace />saveGroupPermissions() {
		document.<portlet:namespace />fm.<portlet:namespace /><%= Constants.CMD %>.value = "group_permissions";
		document.<portlet:namespace />fm.<portlet:namespace />permissionsRedirect.value = "<%= portletURL.toString() %>";
		document.<portlet:namespace />fm.<portlet:namespace />groupIdActionIds.value = Liferay.Util.listSelect(document.<portlet:namespace />fm.<portlet:namespace />current_actions);
		submitForm(document.<portlet:namespace />fm, "<portlet:actionURL><portlet:param name="struts_action" value="/portlet_configuration/edit_permissions" /></portlet:actionURL>");
	}

	function <portlet:namespace />saveGuestPermissions() {
		document.<portlet:namespace />fm.<portlet:namespace /><%= Constants.CMD %>.value = "guest_permissions";
		document.<portlet:namespace />fm.<portlet:namespace />permissionsRedirect.value = "<%= portletURL.toString() %>";
		document.<portlet:namespace />fm.<portlet:namespace />guestActionIds.value = Liferay.Util.listSelect(document.<portlet:namespace />fm.<portlet:namespace />current_actions);
		submitForm(document.<portlet:namespace />fm, "<portlet:actionURL><portlet:param name="struts_action" value="/portlet_configuration/edit_permissions" /></portlet:actionURL>");
	}

	function <portlet:namespace />saveOrganizationPermissions(organizationIdsPos, organizationIdsPosValue) {

		<%
		PortletURL saveOrganizationPermissionsRedirectURL = PortletURLUtil.clone(portletURL, renderResponse);

		new OrganizationSearch(renderRequest, saveOrganizationPermissionsRedirectURL);
		%>

		var organizationIds = document.<portlet:namespace />fm.<portlet:namespace />organizationIds.value;

		if (organizationIdsPos == -1) {
			organizationIds = "";
			organizationIdsPos = 0;
		}

		document.<portlet:namespace />fm.<portlet:namespace /><%= Constants.CMD %>.value = "organization_permissions";
		document.<portlet:namespace />fm.<portlet:namespace />permissionsRedirect.value = "<%= saveOrganizationPermissionsRedirectURL.toString() %>&<portlet:namespace />cur=<%= HtmlUtil.escape(cur) %>&<portlet:namespace />organizationIds=" + organizationIds + "&<portlet:namespace />organizationIdsPos=" + organizationIdsPos;
		document.<portlet:namespace />fm.<portlet:namespace />organizationIds.value = organizationIds;
		document.<portlet:namespace />fm.<portlet:namespace />organizationIdsPosValue.value = organizationIdsPosValue;
		document.<portlet:namespace />fm.<portlet:namespace />organizationIdActionIds.value = Liferay.Util.listSelect(document.<portlet:namespace />fm.<portlet:namespace />current_actions);
		submitForm(document.<portlet:namespace />fm, "<portlet:actionURL><portlet:param name="struts_action" value="/portlet_configuration/edit_permissions" /></portlet:actionURL>");
	}

	function <portlet:namespace />saveRolePermissions(roleIdsPos, roleIdsPosValue) {

		<%
		PortletURL saveRolePermissionsRedirectURL = PortletURLUtil.clone(portletURL, renderResponse);

		new RoleSearch(renderRequest, saveRolePermissionsRedirectURL);
		%>

		var roleIds = document.<portlet:namespace />fm.<portlet:namespace />roleIds.value;

		if (roleIdsPos == -1) {
			roleIds = "";
			roleIdsPos = 0;
		}

		document.<portlet:namespace />fm.<portlet:namespace /><%= Constants.CMD %>.value = "role_permissions";
		document.<portlet:namespace />fm.<portlet:namespace />permissionsRedirect.value = "<%= saveRolePermissionsRedirectURL.toString() %>&<portlet:namespace />cur=<%= HtmlUtil.escape(cur) %>&<portlet:namespace />roleIds=" + roleIds + "&<portlet:namespace />roleIdsPos=" + roleIdsPos;
		document.<portlet:namespace />fm.<portlet:namespace />roleIds.value = roleIds;
		document.<portlet:namespace />fm.<portlet:namespace />roleIdsPosValue.value = roleIdsPosValue;
		document.<portlet:namespace />fm.<portlet:namespace />roleIdActionIds.value = Liferay.Util.listSelect(document.<portlet:namespace />fm.<portlet:namespace />current_actions);
		submitForm(document.<portlet:namespace />fm, "<portlet:actionURL><portlet:param name="struts_action" value="/portlet_configuration/edit_permissions" /></portlet:actionURL>");
	}

	function <portlet:namespace />saveUserGroupPermissions(userGroupIdsPos, userGroupIdsPosValue) {

		<%
		PortletURL saveUserGroupPermissionsRedirectURL = PortletURLUtil.clone(portletURL, renderResponse);

		new UserGroupSearch(renderRequest, saveUserGroupPermissionsRedirectURL);
		%>

		var userGroupIds = document.<portlet:namespace />fm.<portlet:namespace />userGroupIds.value;

		if (userGroupIdsPos == -1) {
			userGroupIds = "";
			userGroupIdsPos = 0;
		}

		document.<portlet:namespace />fm.<portlet:namespace /><%= Constants.CMD %>.value = "user_group_permissions";
		document.<portlet:namespace />fm.<portlet:namespace />permissionsRedirect.value = "<%= saveUserGroupPermissionsRedirectURL.toString() %>&<portlet:namespace />cur=<%= HtmlUtil.escape(cur) %>&<portlet:namespace />userGroupIds=" + userGroupIds + "&<portlet:namespace />userGroupIdsPos=" + userGroupIdsPos;
		document.<portlet:namespace />fm.<portlet:namespace />userGroupIds.value = userGroupIds;
		document.<portlet:namespace />fm.<portlet:namespace />userGroupIdsPosValue.value = userGroupIdsPosValue;
		document.<portlet:namespace />fm.<portlet:namespace />userGroupIdActionIds.value = Liferay.Util.listSelect(document.<portlet:namespace />fm.<portlet:namespace />current_actions);
		submitForm(document.<portlet:namespace />fm, "<portlet:actionURL><portlet:param name="struts_action" value="/portlet_configuration/edit_permissions" /></portlet:actionURL>");
	}

	function <portlet:namespace />saveUserPermissions(userIdsPos, userIdsPosValue) {

		<%
		PortletURL saveUserPermissionsRedirectURL = PortletURLUtil.clone(portletURL, renderResponse);

		new UserSearch(renderRequest, saveUserPermissionsRedirectURL);
		%>

		var userIds = document.<portlet:namespace />fm.<portlet:namespace />userIds.value;

		if (userIdsPos == -1) {
			userIds = "";
			userIdsPos = 0;
		}

		document.<portlet:namespace />fm.<portlet:namespace /><%= Constants.CMD %>.value = "user_permissions";
		document.<portlet:namespace />fm.<portlet:namespace />permissionsRedirect.value = "<%= saveUserPermissionsRedirectURL.toString() %>&<portlet:namespace />cur=<%= HtmlUtil.escape(cur) %>&<portlet:namespace />userIds=" + userIds + "&<portlet:namespace />userIdsPos=" + userIdsPos;
		document.<portlet:namespace />fm.<portlet:namespace />userIds.value = userIds;
		document.<portlet:namespace />fm.<portlet:namespace />userIdsPosValue.value = userIdsPosValue;
		document.<portlet:namespace />fm.<portlet:namespace />userIdActionIds.value = Liferay.Util.listSelect(document.<portlet:namespace />fm.<portlet:namespace />current_actions);
		submitForm(document.<portlet:namespace />fm, "<portlet:actionURL><portlet:param name="struts_action" value="/portlet_configuration/edit_permissions" /></portlet:actionURL>");
	}

	function <portlet:namespace />updateOrganizationPermissions() {
		document.<portlet:namespace />fm.<portlet:namespace />organizationIds.value = Liferay.Util.listCheckedExcept(document.<portlet:namespace />fm, "<portlet:namespace />allRowIds");
		submitForm(document.<portlet:namespace />fm);
	}

	function <portlet:namespace />updateRolePermissions() {
		document.<portlet:namespace />fm.<portlet:namespace />roleIds.value = Liferay.Util.listCheckedExcept(document.<portlet:namespace />fm, "<portlet:namespace />allRowIds");
		submitForm(document.<portlet:namespace />fm);
	}

	function <portlet:namespace />updateUserGroupPermissions() {
		document.<portlet:namespace />fm.<portlet:namespace />userGroupIds.value = Liferay.Util.listCheckedExcept(document.<portlet:namespace />fm, "<portlet:namespace />allRowIds");
		submitForm(document.<portlet:namespace />fm);
	}

	function <portlet:namespace />updateUserPermissions() {
		document.<portlet:namespace />fm.<portlet:namespace />userIds.value = Liferay.Util.listCheckedExcept(document.<portlet:namespace />fm, "<portlet:namespace />allRowIds");
		submitForm(document.<portlet:namespace />fm);
	}
</script>

<div class="edit-permissions">
	<form action="<%= portletURL.toString() %>" method="post" name="<portlet:namespace />fm" onSubmit="submitForm(this); return false;">
	<input name="<portlet:namespace /><%= Constants.CMD %>" type="hidden" value="" />
	<input name="<portlet:namespace />permissionsRedirect" type="hidden" value="" />
	<input name="<portlet:namespace />cur" type="hidden" value="<%= HtmlUtil.escapeAttribute(cur) %>" />
	<input name="<portlet:namespace />resourceId" type="hidden" value="<%= resource.getResourceId() %>" />

	<c:choose>
		<c:when test="<%= Validator.isNull(modelResource) %>">
			<liferay-util:include page="/html/portlet/portlet_configuration/tabs1.jsp">
				<liferay-util:param name="tabs1" value="permissions" />
			</liferay-util:include>
		</c:when>
		<c:otherwise>
			<div>
				<liferay-ui:message key="edit-permissions-for" /> <%= selResourceName %>: <a href="<%= HtmlUtil.escape(redirect) %>"><%= selResourceDescription %></a>
			</div>

			<br />
		</c:otherwise>
	</c:choose>

	<%
	String tabs2Names = "users,organizations,user-groups,regular-roles,community-roles,community,guest";

	if (ResourceActionsUtil.isPortalModelResource(modelResource)) {
		tabs2Names = StringUtil.replace(tabs2Names, "community-roles,", StringPool.BLANK);
		tabs2Names = StringUtil.replace(tabs2Names, "community,", StringPool.BLANK);
		tabs2Names = StringUtil.replace(tabs2Names, ",guest", StringPool.BLANK);
	}
	else if (modelResource.equals(Layout.class.getName())) {
		// User layouts should not have community assignments

		if (group.isUser()) {
			tabs2Names = StringUtil.replace(tabs2Names, "community,", StringPool.BLANK);
			tabs2Names = StringUtil.replace(tabs2Names, "community-roles,", StringPool.BLANK);
		}
		else if (group.isOrganization()) {
			tabs2Names = StringUtil.replace(tabs2Names, "community,", "organization,");
			tabs2Names = StringUtil.replace(tabs2Names, "community-roles,", "organization-roles,");
		}

		// Private layouts should not have guest assignments

		if (selLayout.isPrivateLayout()) {
			tabs2Names = StringUtil.replace(tabs2Names, ",guest", StringPool.BLANK);
		}
	}
	else {
		if (group.isUser()) {
			tabs2Names = StringUtil.replace(tabs2Names, "community,", StringPool.BLANK);
			tabs2Names = StringUtil.replace(tabs2Names, "community-roles,", StringPool.BLANK);
		}
		else if (group.isOrganization()) {
			tabs2Names = StringUtil.replace(tabs2Names, "community,", "organization,");
			tabs2Names = StringUtil.replace(tabs2Names, "community-roles,", "organization-roles,");
		}
	}
	%>

	<c:choose>
		<c:when test="<%= Validator.isNull(modelResource) %>">
			<liferay-ui:tabs
				names="<%= tabs2Names %>"
				param="tabs2"
				url="<%= portletURL.toString() %>"
			/>
		</c:when>
		<c:otherwise>
			<liferay-ui:tabs
				names="<%= tabs2Names %>"
				param="tabs2"
				url="<%= portletURL.toString() %>"
				backURL="<%= redirect %>"
			/>
		</c:otherwise>
	</c:choose>

	<c:choose>
		<c:when test='<%= tabs2.equals("users") %>'>
			<liferay-util:include page="/html/portlet/portlet_configuration/edit_permissions_algorithm_1_to_4_users.jsp" />
		</c:when>
		<c:when test='<%= tabs2.equals("organizations") %>'>
			<liferay-util:include page="/html/portlet/portlet_configuration/edit_permissions_algorithm_1_to_4_organizations.jsp" />
		</c:when>
		<c:when test='<%= tabs2.equals("user-groups") %>'>
			<liferay-util:include page="/html/portlet/portlet_configuration/edit_permissions_algorithm_1_to_4_user_groups.jsp" />
		</c:when>
		<c:when test='<%= tabs2.equals("regular-roles") || tabs2.equals("community-roles") || tabs2.equals("organization-roles") %>'>
			<liferay-util:include page="/html/portlet/portlet_configuration/edit_permissions_algorithm_1_to_4_roles.jsp" />
		</c:when>
		<c:when test='<%= tabs2.equals("community") || tabs2.equals("organization") %>'>
			<input name="<portlet:namespace />groupId" type="hidden" value="<%= groupId %>" />
			<input name="<portlet:namespace />groupIdActionIds" type="hidden" value="" />

			<%
			List permissions = PermissionLocalServiceUtil.getGroupPermissions(groupId, resource.getResourceId());

			List actions1 = ResourceActionsUtil.getResourceActions(portletResource, modelResource);
			List actions2 = ResourceActionsUtil.getActions(permissions);

			// Left list

			List leftList = new ArrayList();

			for (int i = 0; i < actions2.size(); i++) {
				String actionId = (String)actions2.get(i);

				leftList.add(new KeyValuePair(actionId, ResourceActionsUtil.getAction(pageContext, actionId)));
			}

			leftList = ListUtil.sort(leftList, new KeyValuePairComparator(false, true));

			// Right list

			List rightList = new ArrayList();

			for (int i = 0; i < actions1.size(); i++) {
				String actionId = (String)actions1.get(i);

				if (!actions2.contains(actionId)) {
					rightList.add(new KeyValuePair(actionId, ResourceActionsUtil.getAction(pageContext, actionId)));
				}
			}

			rightList = ListUtil.sort(rightList, new KeyValuePairComparator(false, true));
			%>

			<div class="assign-permissions">
				<liferay-ui:input-move-boxes
					formName="fm"
					leftTitle="what-they-can-do"
					rightTitle="what-they-cant-do"
					leftBoxName="current_actions"
					rightBoxName="available_actions"
					leftList="<%= leftList %>"
					rightList="<%= rightList %>"
				/>

				<br />

				<div class="exp-button-holder">
					<input type="button" value="<liferay-ui:message key="save" />" onClick="<portlet:namespace />saveGroupPermissions();" />
				</div>
			</div>
		</c:when>
		<c:when test='<%= tabs2.equals("guest") %>'>
			<input name="<portlet:namespace />guestActionIds" type="hidden" value="" />

			<%
			User guestUser = UserLocalServiceUtil.getDefaultUser(company.getCompanyId());

			List permissions = PermissionLocalServiceUtil.getUserPermissions(guestUser.getUserId(), resource.getResourceId());

			List actions1 = ResourceActionsUtil.getResourceActions(portletResource, modelResource);
			List actions2 = ResourceActionsUtil.getActions(permissions);

			List guestUnsupportedActions = ResourceActionsUtil.getResourceGuestUnsupportedActions(portletResource, modelResource);

			// Left list

			List leftList = new ArrayList();

			for (int i = 0; i < actions2.size(); i++) {
				String actionId = (String)actions2.get(i);

				if (!guestUnsupportedActions.contains(actionId)) {
					leftList.add(new KeyValuePair(actionId, ResourceActionsUtil.getAction(pageContext, actionId)));
				}
			}

			leftList = ListUtil.sort(leftList, new KeyValuePairComparator(false, true));

			// Right list

			List rightList = new ArrayList();

			for (int i = 0; i < actions1.size(); i++) {
				String actionId = (String)actions1.get(i);

				if (!guestUnsupportedActions.contains(actionId)) {
					if (!actions2.contains(actionId)) {
						rightList.add(new KeyValuePair(actionId, ResourceActionsUtil.getAction(pageContext, actionId)));
					}
				}
			}

			rightList = ListUtil.sort(rightList, new KeyValuePairComparator(false, true));
			%>

			<div class="assign-permissions">
				<liferay-ui:input-move-boxes
					formName="fm"
					leftTitle="what-they-can-do"
					rightTitle="what-they-cant-do"
					leftBoxName="current_actions"
					rightBoxName="available_actions"
					leftList="<%= leftList %>"
					rightList="<%= rightList %>"
				/>

				<br />

				<div class="exp-button-holder">
					<input type="button" value="<liferay-ui:message key="save" />" onClick="<portlet:namespace />saveGuestPermissions();" />
				</div>
			</div>
		</c:when>
		<c:when test='<%= false && tabs2.equals("associated") %>'>

			<%
			String selectedActionId = ParamUtil.getString(request, "selectedActionId");
			%>

			<table class="lfr-table">
			<tr>
				<td>
					<liferay-ui:message key="list-users-with-the-permission-to-perform-the-action" />:
				</td>
				<td>
					<select name="<portlet:namespace />selectedActionId">

						<%
						List actions = ResourceActionsUtil.getResourceActions(portletResource, modelResource);

						actions = ListUtil.sort(actions, new ActionComparator(company.getCompanyId(), locale));

						for (int i = 0; i < actions.size(); i++) {
							String actionId = (String)actions.get(i);

							if (selectedActionId.equals("")) {
								selectedActionId = actionId;
							}

							%>
							<option <%= actionId.equals(selectedActionId) ? "selected" : "" %> value="<%= actionId %>"><%= ResourceActionsUtil.getAction(pageContext, actionId) %></option>
						<%
						}
						%>

					</select>
				</td>
			</tr>
			</table>

			<br />

			<%
			portletURL.setParameter("selectedActionId", selectedActionId);

			UserSearch searchContainer = new UserSearch(renderRequest, portletURL);
			%>

			<liferay-ui:search-form
				page="/html/portlet/enterprise_admin/user_search.jsp"
				searchContainer="<%= searchContainer %>"
			/>

			<%
			UserSearchTerms searchTerms = (UserSearchTerms)searchContainer.getSearchTerms();

			int total = UserLocalServiceUtil.getPermissionUsersCount(company.getCompanyId(), groupId, modelResource, resourcePrimKey, selectedActionId, searchTerms.getFirstName(), searchTerms.getMiddleName(), searchTerms.getLastName(), searchTerms.getEmailAddress(), searchTerms.isAndOperator());

			searchContainer.setTotal(total);

			List results = UserLocalServiceUtil.getPermissionUsers(company.getCompanyId(), groupId, modelResource, resourcePrimKey, selectedActionId, searchTerms.getFirstName(), searchTerms.getMiddleName(), searchTerms.getLastName(), searchTerms.getEmailAddress(), searchTerms.isAndOperator(), searchContainer.getStart(), searchContainer.getEnd());

			searchContainer.setResults(results);
			%>

			<div class="separator"><!-- --></div>

			<%
			List<String> headerNames = new ArrayList<String>();

			headerNames.add("name");
			headerNames.add("screen-name");
			//headerNames.add("email-address");

			searchContainer.setHeaderNames(headerNames);

			List resultRows = searchContainer.getResultRows();

			for (int i = 0; i < results.size(); i++) {
				User user2 = (User)results.get(i);

				ResultRow row = new ResultRow(user2, user2.getUserId(), i);

				// Name, screen name, and email address

				row.addText(user2.getFullName());
				row.addText(user2.getScreenName());
				//row.addText(user2.getEmailAddress());

				// Add result row

				resultRows.add(row);
			}
			%>

			<liferay-ui:search-iterator searchContainer="<%= searchContainer %>" />
		</c:when>
	</c:choose>

	</form>
</div>