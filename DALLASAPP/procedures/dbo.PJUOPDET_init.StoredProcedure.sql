USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJUOPDET_init]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJUOPDET_init]
as
SELECT * from PJUOPDET
WHERE
docnbr = 'Z'
GO
