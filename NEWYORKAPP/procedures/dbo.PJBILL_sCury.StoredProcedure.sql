USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJBILL_sCury]    Script Date: 12/21/2015 16:01:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBILL_sCury] @parm1 varchar (4), @parm2 varchar (16)  as
select * from PJBILL
where
billcuryid = @parm1 and
project like @parm2
order by project
GO
