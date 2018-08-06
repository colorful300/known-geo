import 'data_reader.dart';

class RelatedMetadataReader extends DataReader {
  //给出查询的关键字段：
  String title; //用于模糊匹配的标题名称字段，例如：全国硫黄矿调查简报
  String area; //模糊匹配的区域名称，相似度越高越排前，例如：海南省
  String author; //作者名称（模糊搜索），例如：谭锡畴
  String provider; //提供单位（模糊搜索），例如：军事委员会资源委员会
  String mine; //矿种名称（模糊搜索），例如：铁矿,铬矿
  RelatedMetadataReader({
    this.title,
    this.area,
    this.author,
    this.provider,
    this.mine,
  }): super(
    "http://catalog.ngac.org.cn/getRelatedMetadatas",
    'statuCode',
    'Doc_list') {
    if (title != null) headers['Name'] = title;
    if (area != null) headers['Name'] = area;
    if (author != null) headers['Name'] = author;
    if (provider != null) headers['Name'] = provider;
    if (mine != null) headers['Name'] = mine;
  }
}
