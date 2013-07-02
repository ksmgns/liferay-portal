/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.portal.kernel.lar;

import com.liferay.portal.kernel.util.LongWrapper;
import com.liferay.portal.kernel.util.MapUtil;
import com.liferay.portal.kernel.util.StringBundler;
import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.model.ClassedModel;
import com.liferay.portal.model.Portlet;

import java.io.Serializable;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author Mate Thurzo
 * @author Zsolt Berentey
 */
public class ManifestSummary implements Serializable {

	public static String getManifestSummaryKey(
		String modelName, String referrerModelName) {

		if (Validator.isNull(referrerModelName) ||
			modelName.equals(referrerModelName)) {

			return modelName;
		}

		return modelName.concat(StringPool.POUND).concat(referrerModelName);
	}

	public void addConfigurationPortlet(Portlet portlet, String[] options) {
		String rootPortletId = portlet.getRootPortletId();

		if (!_configurationPortletOptions.containsKey(rootPortletId)) {
			_configurationPortlets.add(portlet);
			_configurationPortletOptions.put(rootPortletId, options);
		}
	}

	public void addDataPortlet(Portlet portlet) {
		String rootPortletId = portlet.getRootPortletId();

		if (!_dataRootPortletIds.contains(rootPortletId)) {
			_dataPortlets.add(portlet);
			_dataRootPortletIds.add(rootPortletId);
		}
	}

	public void addModelAdditionCount(
		StagedModelType stagedModelType, long count) {

		addModelAdditionCount(stagedModelType.toString(), count);
	}

	public void addModelAdditionCount(String manifestSummaryKey, long count) {
		LongWrapper modelAdditionCounter = _modelAdditionCounters.get(
			manifestSummaryKey);

		if (modelAdditionCounter == null) {
			modelAdditionCounter = new LongWrapper();

			_modelAdditionCounters.put(
				manifestSummaryKey, modelAdditionCounter);
		}

		modelAdditionCounter.setValue(count);

		_manifestSummaryKeys.add(manifestSummaryKey);
	}

	public void addModelDeletionCount(String manifestSummaryKey, long count) {
		LongWrapper modelDeletionCounter = _modelDeletionCounters.get(
			manifestSummaryKey);

		if (modelDeletionCounter == null) {
			modelDeletionCounter = new LongWrapper();

			_modelDeletionCounters.put(
				manifestSummaryKey, modelDeletionCounter);
		}

		modelDeletionCounter.setValue(count);

		_manifestSummaryKeys.add(manifestSummaryKey);
	}

	public String[] getConfigurationPortletOptions(String rootPortletId) {
		return _configurationPortletOptions.get(rootPortletId);
	}

	public List<Portlet> getConfigurationPortlets() {
		return _configurationPortlets;
	}

	public List<Portlet> getDataPortlets() {
		return _dataPortlets;
	}

	public Date getExportDate() {
		return _exportDate;
	}

	public Collection<String> getManifestSummaryKeys() {
		return _manifestSummaryKeys;
	}

	public long getModelAdditionCount(Class<? extends ClassedModel> clazz) {
		return getModelAdditionCount(clazz, clazz);
	}

	public long getModelAdditionCount(
		Class<? extends ClassedModel> clazz,
		Class<? extends ClassedModel> referrerClass) {

		return getModelAdditionCount(clazz.getName(), referrerClass.getName());
	}

	public long getModelAdditionCount(String manifestSummaryKey) {
		if (!_modelAdditionCounters.containsKey(manifestSummaryKey)) {
			return -1;
		}

		LongWrapper modelAdditionCounter = _modelAdditionCounters.get(
			manifestSummaryKey);

		return modelAdditionCounter.getValue();
	}

	public long getModelAdditionCount(
		String className, String referrerClassName) {

		String manifestSummaryKey = getManifestSummaryKey(
			className, referrerClassName);

		return getModelAdditionCount(manifestSummaryKey);
	}

	public Map<String, LongWrapper> getModelAdditionCounters() {
		return _modelAdditionCounters;
	}

	public long getModelDeletionCount(Class<? extends ClassedModel> clazz) {
		return getModelDeletionCount(clazz.getName());
	}

	public long getModelDeletionCount(String modelName) {
		if (!_modelDeletionCounters.containsKey(modelName)) {
			return -1;
		}

		LongWrapper modelDeletionCounter = _modelDeletionCounters.get(
			modelName);

		return modelDeletionCounter.getValue();
	}

	public Map<String, LongWrapper> getModelDeletionCounters() {
		return _modelDeletionCounters;
	}

	public void incrementModelAdditionCount(StagedModelType stagedModelType) {
		String manifestSummaryKey = stagedModelType.toString();

		if (!_modelAdditionCounters.containsKey(manifestSummaryKey)) {
			_modelAdditionCounters.put(manifestSummaryKey, new LongWrapper(1));

			_manifestSummaryKeys.add(manifestSummaryKey);

			return;
		}

		LongWrapper modelAdditionCounter = _modelAdditionCounters.get(
			manifestSummaryKey);

		modelAdditionCounter.increment();
	}

	public void incrementModelDeletionCount(StagedModelType stagedModelType) {
		String manifestSummaryKey = stagedModelType.toString();

		if (!_modelDeletionCounters.containsKey(manifestSummaryKey)) {
			_modelDeletionCounters.put(manifestSummaryKey, new LongWrapper(1));

			_manifestSummaryKeys.add(manifestSummaryKey);

			return;
		}

		LongWrapper modelDeletionCounter = _modelDeletionCounters.get(
			manifestSummaryKey);

		modelDeletionCounter.increment();
	}

	public void setExportDate(Date exportDate) {
		_exportDate = exportDate;
	}

	@Override
	public String toString() {
		StringBundler sb = new StringBundler(5);

		sb.append("{modelAdditionCounters=");
		sb.append(MapUtil.toString(_modelAdditionCounters));
		sb.append(", modelDeletionCounters=");
		sb.append(MapUtil.toString(_modelDeletionCounters));
		sb.append("}");

		return sb.toString();
	}

	private Map<String, String[]> _configurationPortletOptions =
		new HashMap<String, String[]>();
	private List<Portlet> _configurationPortlets = new ArrayList<Portlet>();
	private List<Portlet> _dataPortlets = new ArrayList<Portlet>();
	private Set<String> _dataRootPortletIds = new HashSet<String>();
	private Date _exportDate;
	private Set<String> _manifestSummaryKeys = new HashSet<String>();
	private Map<String, LongWrapper> _modelAdditionCounters =
		new HashMap<String, LongWrapper>();
	private Map<String, LongWrapper> _modelDeletionCounters =
		new HashMap<String, LongWrapper>();

}