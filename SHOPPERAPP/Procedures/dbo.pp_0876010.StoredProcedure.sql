USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[pp_0876010]    Script Date: 12/21/2015 16:13:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pp_0876010] @RI_ID SMALLINT

AS

Delete from ARprintQueue where RI_ID = @RI_ID
GO
