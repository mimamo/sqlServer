USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WOBOM_Not_Obs]    Script Date: 12/21/2015 15:49:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[WOBOM_Not_Obs]
	@KitID         char (30)

as

   SELECT         *
   FROM           Kit
   WHERE          KitId like @KitID and
                  Status <> 'O'
   ORDER BY       KitId, SiteID, Status
GO
