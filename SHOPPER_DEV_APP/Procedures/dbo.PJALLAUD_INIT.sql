USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLAUD_INIT]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLAUD_INIT] as
select * from PJALLAUD
where  FISCALNO         = 'Z' and
SYSTEM_CD        = 'Z' and
BATCH_ID         = 'Z' and
DETAIL_NUM       =  9 and
AUDIT_DETAIL_NUM =  9
GO
