USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJINVHDR_Init]    Script Date: 12/21/2015 14:17:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure  [dbo].[PJINVHDR_Init]
as
select * from  PJINVHDR
where draft_num = 'Z'
GO
