USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_init]    Script Date: 12/21/2015 13:57:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVCAT_init] as
SELECT  *    from PJREVCAT
WHERE       pjrevcat.project = 'Z' and
pjrevcat.revid = 'Z' and
pjrevcat.pjt_entity = 'Z' and
pjrevcat.acct = 'Z'
GO
