USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCHARGD_SPK0]    Script Date: 12/21/2015 14:34:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCHARGD_SPK0]  @parm1 varchar (10) , @parm2beg int , @parm2end int   as
select * from PJCHARGD
where    batch_id    = @parm1
and    detail_num between  @parm2beg and @parm2end
order by batch_id,
detail_num
GO
