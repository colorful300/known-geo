import 'data_reader.dart';

class MetadataReader extends DataReader {
  //给出查询的关键字段：
  String keyword; //用于模糊匹配所有搜索字段
  String index; //档号（精确查找），例如:cgdoi.n0001/x00080686
  String title; //标题（模糊搜索），例如:水资源紧缺
  String author; //作者（作者名完整名搜索匹配，包含该作者在内即可），例如:谷振峰
  String organization; //形成单位（单位完整名称搜索匹配，包含该单位名即可），例如:山东省地矿局水资源专题研究组
  String language; //语种，（选其中一种即可），例如:中文、英文、俄文、日文、法文、德文、其他（查询时按给出的样式进行填写）
  String mine; //矿种（模糊搜索），例如:金(金矿)
  String timeRange; //用于搜索文档形成的时间段(包含起、始时间两个值)，例如:2014-04-21,2014-04-23（两个时间中间用英文逗号隔开）
  String caseType; //案卷分类，（请填写完整的），例如:案卷级、文件级、（不填:即表示全部）
  String area; //区域名称，（可模糊搜索），例如:山东省
  String statusCodeEx; //工作程度（精确查找），文档上没有具体说明，暂时不管
  String cateCodeEx; //专业分类（精确查找），文档上没有具体说明，暂时不管
  //给出查询的分页参数：
  String indexPage; //起始页，不填写时，默认值是1
  String pageRows; //每页条数，不填写时，默认值是10

  MetadataReader({
    this.keyword,
    this.index,
    this.title,
    this.author,
    this.organization,
    this.language,
    this.mine,
    this.timeRange,
    this.caseType,
    this.area,
    this.statusCodeEx,
    this.cateCodeEx,
    this.indexPage,
    this.pageRows,
  }): super(
    "http://catalog.ngac.org.cn/clients/getMetadatas",
    'statuCode',
    'docs') {
    if (keyword != null) headers['KeyWord'] = keyword;
    if (index != null) headers['MdIdnt'] = index;
    if (title != null) headers['MdTitle'] = title;
    if (author != null) headers['Auther'] = author;
    if (organization != null) headers['IdContOrg'] = organization;
    if (language != null) headers['DesLangName'] = language;
    if (mine != null) headers['MineralName'] = mine;
    if (timeRange != null) headers['FormTime'] = timeRange;
    if (caseType != null) headers['HiName'] = caseType;
    if (area != null) headers['GeoInfoName'] = area;
    if (statusCodeEx != null) headers['StatuCode'] = statusCodeEx;
    if (cateCodeEx != null) headers['CateCode'] = cateCodeEx;
    if (indexPage != null) headers['indexPage'] = indexPage;
    if (pageRows != null) headers['pageRows'] = pageRows;
  }
}
