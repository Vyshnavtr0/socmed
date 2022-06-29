class ordermodel {
  String? phone;
  String? email;
  String? name;
  String? order;
  String? price;
  String? link;
  String? item;
  String? status;

  ordermodel(
      {this.email,
      this.name,
      this.phone,
      this.order,
      this.price,
      this.link,
      this.item,
      this.status});

  factory ordermodel.fromMap(map) {
    return ordermodel(
        phone: map('phone'),
        email: map('email'),
        name: map('name'),
        order: map('order'),
        price: map('price'),
        link: map('link'),
        item: map('item'),
        status: map('status'));
  }

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email,
      'name': name,
      'order': order,
      'price': price,
      'link': link,
      'item': item,
      'status': status
    };
  }
}
