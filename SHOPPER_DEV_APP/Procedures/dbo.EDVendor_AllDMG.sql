USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVendor_AllDMG]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDVendor_All    Script Date: 5/28/99 1:17:46 PM ******/
CREATE PROCEDURE [dbo].[EDVendor_AllDMG]
 @parm1 varchar( 15 )
AS
 SELECT *
 FROM EDVendor
 WHERE VendId LIKE @parm1
 ORDER BY VendId
GO
