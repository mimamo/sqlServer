USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLOC_SPK1]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLOC_SPK1]  @parm1 varchar (4) ,@parm2beg smallint ,@parm2end smallint   as
select * from PJALLOC
where    alloc_method_cd = @parm1 and
step_number between @parm2beg and @parm2end
order by alloc_method_cd , step_number
GO
