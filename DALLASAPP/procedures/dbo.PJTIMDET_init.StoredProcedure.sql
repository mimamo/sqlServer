USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMDET_init]    Script Date: 12/21/2015 13:45:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMDET_init]
as
SELECT * from PJTIMDET
WHERE
docnbr = 'Z'
GO
