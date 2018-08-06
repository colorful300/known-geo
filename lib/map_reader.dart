import 'data_reader.dart';

class MapReader extends DataReader {
  //给出查询的关键字段：
  String name; //用于模糊匹配服务名称字段，例如：1:25万地质图H45C004003幅数据
  String rid; //模糊匹配比例尺，相似度越高越排前，例如：1:25万
  String type; //服务类型（模糊搜索），例如：WMTS
  String provider; //提供单位（模糊搜索），例如：全国地质资料馆
  String abstract; //资源描述（模糊搜索），例如：水资源分布图
  //给出查询的分页参数：
  String indexPage; //起始页，不填写时，默认值是1
  String pageRows; //每页条数，不填写时，默认值是10

  MapReader({
    this.name,
    this.rid,
    this.type,
    this.provider,
    this.abstract,
    this.indexPage,
    this.pageRows,
  }): super(
    "http://catalog.ngac.org.cn/serviceManager/getServiceInf",
    'status',
    'serviceinf_list') {
    if (name != null) headers['servname'] = name;
    if (rid != null) headers['rid'] = rid;
    if (type != null) headers['servtype'] = type;
    if (provider != null) headers['servproname'] = provider;
    if (abstract != null) headers['servabstract'] = abstract;
    if (indexPage != null) headers['indexPage'] = indexPage;
    if (pageRows != null) headers['pageRows'] = pageRows;
  }
}
