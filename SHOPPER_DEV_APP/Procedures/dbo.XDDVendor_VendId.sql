USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDVendor_VendId]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDVendor_VendId]
  @parm1      varchar(15)
AS
  Select      *
  FROM        Vendor
  WHERE       VendId LIKE @parm1
  ORDER BY    VendId
GO
