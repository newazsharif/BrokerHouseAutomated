USE [Escrow.BOAS]
GO

/****** Object:  Table [Instrument].[tblInstrumentManualInOut]    Script Date: 2/9/2016 5:55:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Instrument].[tblInstrumentManualInOut](
	[id] [numeric](20, 0) IDENTITY(1,1) NOT NULL,
	[client_id] [varchar](10) NOT NULL,
	[instrument_id] [numeric](4, 0) NOT NULL,
	[transaction_date] [numeric](9, 0) NOT NULL,
	[reference_no] [varchar](50) NULL,
	[transaction_type_id] [numeric](4, 0) NOT NULL,
	[quantity] [numeric](15, 0) NOT NULL,
	[rate] [numeric](30, 10) NOT NULL,
	[remarks] [varchar](500) NULL,
	[active_status_id] [int] NOT NULL,
	[membership_id] [numeric](9, 0) NOT NULL,
	[changed_user_id] [nvarchar](128) NOT NULL,
	[changed_date] [datetime] NOT NULL,
	[is_dirty] [numeric](1, 0) NOT NULL,
 CONSTRAINT [PK_tblInstrumentManualInOut] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [InstrumentManagement]
) ON [InstrumentManagement]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [Instrument].[tblInstrumentManualInOut] ADD  CONSTRAINT [DF_tblInstrumentManualInOut_changed_date]  DEFAULT (getdate()) FOR [changed_date]
GO

ALTER TABLE [Instrument].[tblInstrumentManualInOut] ADD  CONSTRAINT [DF_tblInstrumentManualInOut_is_dirty]  DEFAULT ((1)) FOR [is_dirty]
GO

ALTER TABLE [Instrument].[tblInstrumentManualInOut]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrumentManualInOut_DimDate] FOREIGN KEY([transaction_date])
REFERENCES [dbo].[DimDate] ([DateKey])
GO

ALTER TABLE [Instrument].[tblInstrumentManualInOut] CHECK CONSTRAINT [FK_tblInstrumentManualInOut_DimDate]
GO

ALTER TABLE [Instrument].[tblInstrumentManualInOut]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrumentManualInOut_tblConstantObjectValue] FOREIGN KEY([transaction_type_id])
REFERENCES [dbo].[tblConstantObjectValue] ([object_value_id])
GO

ALTER TABLE [Instrument].[tblInstrumentManualInOut] CHECK CONSTRAINT [FK_tblInstrumentManualInOut_tblConstantObjectValue]
GO

ALTER TABLE [Instrument].[tblInstrumentManualInOut]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrumentManualInOut_tblInstrument] FOREIGN KEY([instrument_id])
REFERENCES [Instrument].[tblInstrument] ([id])
GO

ALTER TABLE [Instrument].[tblInstrumentManualInOut] CHECK CONSTRAINT [FK_tblInstrumentManualInOut_tblInstrument]
GO

ALTER TABLE [Instrument].[tblInstrumentManualInOut]  WITH CHECK ADD  CONSTRAINT [FK_tblInstrumentManualInOut_tblInvestor] FOREIGN KEY([client_id])
REFERENCES [Investor].[tblInvestor] ([client_id])
GO

ALTER TABLE [Instrument].[tblInstrumentManualInOut] CHECK CONSTRAINT [FK_tblInstrumentManualInOut_tblInvestor]
GO


