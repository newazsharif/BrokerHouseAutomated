
--GO
------------------------------------------------Create fund balance history table with pk, fk, partition
--print 'Create fund balance history table with pk, fk'
--CREATE TABLE [Investor].[tblInvestorFundBalanceHistory](
--	[client_id] [varchar](10) NOT NULL,
--	[transaction_date] [numeric](9, 0) NOT NULL,
--	[account_type_id] [numeric](4, 0) NULL,
--	[available_balance] [numeric](30, 10) NOT NULL,
--	[sale_receivable] [numeric](30, 10) NOT NULL,
--	[un_clear_cheque] [numeric](30, 10) NOT NULL,
--	[ledger_balance] [numeric](30, 10) NOT NULL CONSTRAINT [DF_tblInvestorFundBalanceHistory_ledger_balance]  DEFAULT ((0)),
--	[total_deposit] [numeric](30, 10) NOT NULL,
--	[share_transfer_in] [numeric](30, 10) NOT NULL,
--	[total_withdraw] [numeric](30, 10) NOT NULL,
--	[share_transfer_out] [numeric](30, 10) NOT NULL,
--	[realized_interest] [numeric](30, 10) NOT NULL,
--	[realized_charge] [numeric](30, 10) NOT NULL,
--	[accured_interest] [numeric](30, 10) NOT NULL,
--	[fund_withdrawal_request] [numeric](30, 10) NOT NULL,
--	[cost_value] [numeric](30, 10) NOT NULL,
--	[market_value] [numeric](30, 10) NOT NULL,
--	[equity] [numeric](30, 10) NOT NULL,
--	[marginable_equity] [numeric](30, 10) NOT NULL,
--	[sanction_amount] [numeric](30, 10) NOT NULL,
--	[loan_ratio] [numeric](15, 10) NOT NULL,
--	[purchase_power] [numeric](30, 10) NOT NULL,
--	[max_withdraw_limit] [numeric](30, 10) NOT NULL,
--	[excess_over_limit] [numeric](30, 10) NOT NULL,
--	[realized_gain] [numeric](30, 10) NOT NULL,
--	[unrealized_gain] [numeric](30, 10) NOT NULL,
--	[active_status_id] [int] NOT NULL,
--	[membership_id] [numeric](9, 0) NOT NULL,
--	[changed_user_id] [nvarchar](128) NOT NULL,
--	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblClientFundBalanceHistory_changed_date]  DEFAULT (getdate()),
--	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblClientFundBalanceHistory_is_dirty]  DEFAULT ((1)),
-- CONSTRAINT [PK_tblClientFundBalanceHistory] PRIMARY KEY CLUSTERED 
--(
--	[client_id] ASC,
--	[transaction_date] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--)

--GO
--SET ANSI_PADDING OFF
--GO
--ALTER TABLE [Investor].[tblInvestorFundBalanceHistory]  WITH CHECK ADD  CONSTRAINT [FK_tblClientFundBalanceHistory_tblInvestor] FOREIGN KEY([client_id])
--REFERENCES [Investor].[tblInvestor] ([client_id])
--GO
--ALTER TABLE [Investor].[tblInvestorFundBalanceHistory] CHECK CONSTRAINT [FK_tblClientFundBalanceHistory_tblInvestor]
--GO
--ALTER TABLE [Investor].[tblInvestorFundBalanceHistory]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorFundBalanceHistory_DimDate] FOREIGN KEY([transaction_date])
--REFERENCES [dbo].[DimDate] ([DateKey])
--GO
--ALTER TABLE [Investor].[tblInvestorFundBalanceHistory] CHECK CONSTRAINT [FK_tblInvestorFundBalanceHistory_DimDate]
--GO
--ALTER TABLE [Investor].[tblInvestorFundBalanceHistory]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorFundBalanceHistory_tblConstantObjectValue] FOREIGN KEY([account_type_id])
--REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
--GO
--ALTER TABLE [Investor].[tblInvestorFundBalanceHistory] CHECK CONSTRAINT [FK_tblInvestorFundBalanceHistory_tblConstantObjectValue]

--GO
--print 'Create share balance history table with pk, fk'
--CREATE TABLE [Investor].[tblInvestorShareBalanceHistory](
--	[transaction_date] [numeric](9, 0) NOT NULL,
--	[client_id] [varchar](10) NOT NULL,
--	[instrument_id] [numeric](4, 0) NOT NULL,
--	[ledger_quantity] [numeric](15, 0) NOT NULL,
--	[salable_quantity] [numeric](15, 0) NOT NULL,
--	[ipo_receivable_quantity] [numeric](15, 0) NOT NULL,
--	[bonus_receivable_quantity] [numeric](15, 0) NOT NULL,
--	[lock_quantity] [numeric](15, 0) NOT NULL,
--	[pledge_quantity] [numeric](15, 0) NOT NULL,
--	[cost_average] [numeric](30, 10) NOT NULL,
--	[cost_value] [numeric](30, 10) NOT NULL,
--	[market_price] [numeric](30, 10) NOT NULL,
--	[market_value] [numeric](30, 10) NOT NULL,
--	[active_status_id] [int] NOT NULL,
--	[membership_id] [numeric](9, 0) NOT NULL,
--	[changed_user_id] [nvarchar](128) NOT NULL,
--	[changed_date] [datetime] NOT NULL CONSTRAINT [DF_tblInvestorShareBalanceHistory_changed_date]  DEFAULT (getdate()),
--	[is_dirty] [numeric](1, 0) NOT NULL CONSTRAINT [DF_tblInvestorShareBalanceHistory_is_dirty]  DEFAULT ((1)),
-- CONSTRAINT [PK_tblInvestorShareBalanceHistory] PRIMARY KEY CLUSTERED 
--(
--	[transaction_date] ASC,
--	[client_id] ASC,
--	[instrument_id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
--)

--GO
--ALTER TABLE [Investor].[tblInvestorShareBalanceHistory]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorShareBalanceHistory_DimDate] FOREIGN KEY([transaction_date])
--REFERENCES [dbo].[DimDate] ([DateKey])

--GO
--ALTER TABLE [Investor].[tblInvestorShareBalanceHistory] CHECK CONSTRAINT [FK_tblInvestorShareBalanceHistory_DimDate]

--GO
--ALTER TABLE [Investor].[tblInvestorShareBalanceHistory]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorShareBalanceHistory_tblInstrument] FOREIGN KEY([instrument_id])
--REFERENCES [Instrument].[tblInstrument] ([id])

--GO
--ALTER TABLE [Investor].[tblInvestorShareBalanceHistory] CHECK CONSTRAINT [FK_tblInvestorShareBalanceHistory_tblInstrument]

--GO
--ALTER TABLE [Investor].[tblInvestorShareBalanceHistory]  WITH CHECK ADD  CONSTRAINT [FK_tblInvestorShareBalanceHistory_tblInvestor] FOREIGN KEY([client_id])
--REFERENCES [Investor].[tblInvestor] ([client_id])

--GO
--ALTER TABLE [Investor].[tblInvestorShareBalanceHistory] CHECK CONSTRAINT [FK_tblInvestorShareBalanceHistory_tblInvestor]

--GO
--print 'Partition Fund Balance History Table'
--ALTER TABLE [Investor].[tblInvestorFundBalanceHistory] DROP CONSTRAINT [PK_tblClientFundBalanceHistory]
--ALTER TABLE [Investor].[tblInvestorFundBalanceHistory] ADD  CONSTRAINT [PK_tblClientFundBalanceHistory] PRIMARY KEY CLUSTERED 
--(
--	[client_id] ASC,
--	[transaction_date] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [investor_fund_balance]([transaction_date])

--GO
--print 'Partition Share Balance History Table'
--ALTER TABLE [Investor].[tblInvestorShareBalanceHistory] DROP CONSTRAINT [PK_tblInvestorShareBalanceHistory]
--ALTER TABLE [Investor].[tblInvestorShareBalanceHistory] ADD  CONSTRAINT [PK_tblInvestorShareBalanceHistory] PRIMARY KEY CLUSTERED 
--(
--	[transaction_date] ASC,
--	[client_id] ASC,
--	[instrument_id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [tblInvestorShareBalance]([transaction_date])

--GO
--print 'Create non cluster index Fund Balance History Table'
--CREATE NONCLUSTERED INDEX [idx_member_date_client] ON [Investor].[tblInvestorFundBalanceHistory]
--(
--	[membership_id] ASC,
--	[transaction_date] ASC,
--	[client_id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

--GO
--print 'Create non cluster index share Balance History Table'
--CREATE NONCLUSTERED INDEX [idx_member_date_client_instrument] ON [Investor].[tblInvestorShareBalanceHistory]
--(
--	[membership_id] ASC,
--	[transaction_date] ASC,
--	[client_id] ASC,
--	[instrument_id] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

--GO
--print 'Current data transfer to #fundBalance'
--select IFB.* into #fundBalance 
--from Investor.tblInvestorFundBalance IFB
--	INNER JOIN (SELECT client_id, MAX(transaction_date) transaction_date FROM Investor.tblInvestorFundBalance) IFB2
--	ON IFB.client_id=IFB2.client_id AND IFB.transaction_date=IFB2.transaction_date

--print 'Other data transfer to fund balance history table'
--insert into Investor.tblInvestorFundBalanceHistory
--select ifb.* 
--from 
--	Investor.tblInvestorFundBalance ifb
--left join 
--	#fundBalance fb 
--	on ifb.transaction_date=fb.transaction_date
--	and ifb.client_id=fb.client_id
--where fb.client_id is null

--print 'truncate current fund balance table'
--truncate table investor.tblInvestorFundBalance

--print '#fundBalance data transfer to current fund balance table'
--insert into Investor.tblInvestorFundBalance
--select fb.* 
--from 
--	#fundBalance fb 

--UPDATE Investor.tblInvestorFundBalance SET transaction_date=dbo.sfun_get_process_date()

--GO
--print 'Current data transfer to #shareBalance'
--select ISB.* into #shareBalance 
--from 
--	Investor.tblInvestorShareBalance ISB
--INNER JOIN 
--	(SELECT client_id, instrument_id, MAX(transaction_date) transaction_date FROM Investor.tblInvestorShareBalance) ISB2
--	ON ISB.client_id=ISB2.client_id
--	AND ISB.instrument_id=ISB2.instrument_id
--	AND ISB.transaction_date=ISB2.transaction_date

--print 'Other data transfer to share balance history table'
--insert into Investor.tblInvestorshareBalanceHistory
--select ifb.* 
--from 
--	Investor.tblInvestorshareBalance ifb
--left join 
--	#shareBalance fb 
--	on ifb.transaction_date=fb.transaction_date
--	and ifb.client_id=fb.client_id
--where fb.client_id is null

--print 'truncate current share balance table'
--truncate table investor.tblInvestorshareBalance

--print '#shareBalance data transfer to current share balance table'
--insert into Investor.tblInvestorshareBalance
--select fb.* 
--from 
--	#shareBalance fb 

--UPDATE Investor.tblInvestorshareBalance SET transaction_date=dbo.sfun_get_process_date()