USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVCAT_init]    Script Date: 12/16/2015 15:55:28 ******/
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
