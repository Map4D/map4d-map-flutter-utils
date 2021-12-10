package vn.map4d.maputils.map4d_map_utils;

import vn.map4d.types.MFLocationCoordinate;
import vn.map4d.utils.android.clustering.MFClusterItem;

public class FMFClusterItem implements MFClusterItem {

  private final MFLocationCoordinate mPosition;
  private String mTitle;
  private String mSnippet;
  private Integer mItemNo;

  public FMFClusterItem(double lat, double lng) {
    mPosition = new MFLocationCoordinate(lat, lng);
    mTitle = null;
    mSnippet = null;
    mItemNo = null;
  }

  public FMFClusterItem(double lat, double lng, String title, String snippet, Integer itemNo) {
    mPosition = new MFLocationCoordinate(lat, lng);
    mTitle = title;
    mSnippet = snippet;
    mItemNo = itemNo;
  }

  public Integer getItemNo() {
    return mItemNo;
  }

  @Override
  public MFLocationCoordinate getPosition() {
    return mPosition;
  }

  @Override
  public String getTitle() {
    return mTitle;
  }

  /**
   * Set the title of the marker
   *
   * @param title string to be set as title
   */
  public void setTitle(String title) {
    mTitle = title;
  }

  @Override
  public String getSnippet() {
    return mSnippet;
  }

  /**
   * Set the description of the marker
   *
   * @param snippet string to be set as snippet
   */
  public void setSnippet(String snippet) {
    mSnippet = snippet;
  }
}
