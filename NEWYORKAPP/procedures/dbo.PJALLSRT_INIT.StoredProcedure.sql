USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLSRT_INIT]    Script Date: 12/21/2015 16:01:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLSRT_INIT] as
select * from PJALLSRT
where src_project = ' '
and allsrt_key    = 0
GO
