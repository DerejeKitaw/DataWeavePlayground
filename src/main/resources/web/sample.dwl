%dw 2.0
output application/json
import * from dw::core::Arrays

fun getOrders(customer) =
	payload.Root.Orders.*Order
	filter (value, index) -> (value.CustomerID == customer.@CustomerID)

---
payload.Root.Customers.*Customer map {
	CustomerID: $.@CustomerID,
	CompanyName: $.CompanyName,
	Phone: $.Phone,
	FullAddress: joinBy(($.FullAddress pluck((value) -> value)), ' '),
	Orders:	take(getOrders($) orderBy -($.OrderDate as DateTime), 3) map {
		OrderDate: $.OrderDate as DateTime,
		ShipName: $.ShipInfo.ShipName
	}
}