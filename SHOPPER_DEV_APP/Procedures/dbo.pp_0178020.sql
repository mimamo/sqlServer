USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_0178020]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pp_0178020] @RI_ID SMALLINT

AS

Delete from WrkBudgetDetail where RI_ID = @RI_ID
GO
