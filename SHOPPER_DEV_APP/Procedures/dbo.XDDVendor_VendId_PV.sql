USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDVendor_VendId_PV]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDVendor_VendId_PV]
  @parm1      	varchar(15)
AS
--  Select      	*
--  FROM        	Vendor Left Outer Join XDDDepositor
--  		On Vendor.VendID = XDDDepositor.VendID and XDDDepositor.VendCust = 'V'
--  WHERE       	Vendor.VendId LIKE @parm1
--  ORDER BY    	Vendor.VendId

  Select      	Vendor.VendID, Vendor.Name, XDDDepositor.PNStatus, XDDDepositor.Status, XDDDepositor.EntryClass, XDDDepositor.FormatID, XDDDepositor.AcctAppStatus
  FROM        	Vendor Left Outer Join XDDDepositor
  		On Vendor.VendID = XDDDepositor.VendID and XDDDepositor.VendCust = 'V'
  WHERE       	Vendor.VendId LIKE @parm1
  ORDER BY    	Vendor.VendId
GO
