USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[pp_SN65000]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pp_SN65000] @RI_ID SMALLINT

AS

Delete from SNprintQueue where RI_ID = @RI_ID
GO
