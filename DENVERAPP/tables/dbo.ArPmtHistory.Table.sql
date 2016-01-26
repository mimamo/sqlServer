USE [DENVERAPP]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

/*******************************************************************************************************
*   DENVERAPP.dbo.arPmtHistory 
*
*   Creator:       Michelle Morales
*   Date:          01/13/2015
*   
*
*   Notes:      select top 100 * from DEN_DEV_APP.dbo.arPmtHistory    
*
*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/

create TABLE [dbo].[arPmtHistory]
(
	Invoice	varchar(10),
	Job	varchar(16),
	JobName	varchar(60),
	InvoiceContact varchar(20),
	ClientContactName varchar(30),
	InvoiceDate	varchar(10),
	DueDate	varchar(10),
	PaidDate varchar(10),
	InvoiceAmount decimal(20,2),
	PaidAmount decimal(20,2),
	Balance	decimal(20,2),
	PaymentDays	int,
	Customer varchar(15),
	runDate datetime NOT NULL,
	CONSTRAINT [pkc_arPaymentHistory_Customer_Invoice_Job] PRIMARY KEY CLUSTERED ([Customer], [Invoice], [Job] ASC)
WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

