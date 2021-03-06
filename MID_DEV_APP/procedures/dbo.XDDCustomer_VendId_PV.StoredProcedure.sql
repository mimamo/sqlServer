USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDCustomer_VendId_PV]    Script Date: 12/21/2015 14:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDCustomer_VendId_PV]
  @parm1      	varchar(15)
AS
  Select      	Customer.CustID, Customer.Name, XDDDepositor.PNStatus, XDDDepositor.Status, XDDDepositor.EntryClass, XDDDepositor.FormatID, XDDDepositor.AcctAppStatus
  FROM        	Customer Left Outer Join XDDDepositor
  		On Customer.CustID = XDDDepositor.VendID and XDDDepositor.VendCust = 'C'
  WHERE       	Customer.CustID LIKE @parm1
  ORDER BY    	Customer.CustID
GO
