USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_CleanWrkRelease_PO]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[pp_CleanWrkRelease_PO]  @UserAddress char(21)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	DELETE WrkRelease_PO where UserAddress = @UserAddress
GO
