USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pp_0178020]    Script Date: 12/21/2015 16:13:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pp_0178020] @RI_ID SMALLINT

AS

Delete from WrkBudgetDetail where RI_ID = @RI_ID
GO
