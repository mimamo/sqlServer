USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDVendor_all]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDVendor_all]
 @parm1 varchar( 15 )
AS
 SELECT *
 FROM EDVendor
 WHERE VendId LIKE @parm1
 ORDER BY VendId
GO
