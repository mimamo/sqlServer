USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pp_SD65000]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pp_SD65000] @RI_ID SMALLINT

AS

Delete from SDprintQueue where RI_ID = @RI_ID
GO
