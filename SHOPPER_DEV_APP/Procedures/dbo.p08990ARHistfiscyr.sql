USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[p08990ARHistfiscyr]    Script Date: 12/16/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[p08990ARHistfiscyr] As

SELECT min(fiscyr) FROM ARHIST
GO
