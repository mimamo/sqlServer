USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTIMHDR_init]    Script Date: 12/21/2015 15:37:03 ******/
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
