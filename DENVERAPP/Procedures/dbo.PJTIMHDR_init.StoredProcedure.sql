USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMHDR_init]    Script Date: 12/21/2015 15:43:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTIMHDR_init]
as
SELECT * from PJTIMHDR
WHERE
docnbr = 'Z'
GO
