USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990ARHistfiscyr]    Script Date: 12/21/2015 14:17:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[p08990ARHistfiscyr] As

SELECT min(fiscyr) FROM ARHIST
GO
