USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDVendor_VendId]    Script Date: 12/21/2015 13:57:20 ******/
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
