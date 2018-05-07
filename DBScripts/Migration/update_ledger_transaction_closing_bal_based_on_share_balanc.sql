use [Escrow.BOAS];
with isb as
(
	select
		tisb.client_id, tisb.instrument_id, tisb.ledger_quantity, tisb.cost_average, tisb.cost_value
	from 
		Investor.tblInvestorShareBalance tisb
	inner join 
		Instrument.tblInstrument tins 
		on tins.id = tisb.instrument_id
	inner join 
		Investor.tblInvestor tinv 
		on tinv.client_id = tisb.client_id
	where
		tisb.transaction_date = 
			(
				select max(stisb.transaction_date)
				from Investor.tblInvestorShareBalance stisb
				where stisb.client_id = tisb.client_id
				and stisb.instrument_id = tisb.instrument_id
			)
)
, isl as
(
	select
		tisb.client_id, tisb.instrument_id, tisb.transaction_date, tisb.closing_qty, tisb.closing_rate, tisb.closing_cost
	from 
		Investor.tblInvestorShareLedger tisb
	inner join 
		Instrument.tblInstrument tins 
		on tins.id = tisb.instrument_id
	inner join 
		Investor.tblInvestor tinv 
		on tinv.client_id = tisb.client_id
	where
		tisb.transaction_date = 
			(
				select max(stisb.transaction_date)
				from Investor.tblInvestorShareLedger stisb
				where stisb.client_id = tisb.client_id
				and stisb.instrument_id = tisb.instrument_id
			)
)--288755

update isl
set isl.closing_qty=isb.ledger_quantity
	, isl.closing_rate=isb.cost_average
	, isl.closing_cost=isb.cost_value
--select 
--	* 
from 
	isb 
inner join
	isl
	on isb.client_id=isl.client_id
	and isb.instrument_id=isl.instrument_id
inner join 
	Instrument.tblInstrument ins
	on isl.instrument_id=ins.id
inner join
	Portfolio_Status ps
	on isl.client_id=ps.ClientCode
	and ins.isin=ps.isin
