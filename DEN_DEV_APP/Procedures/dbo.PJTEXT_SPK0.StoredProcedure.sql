USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTEXT_SPK0]    Script Date: 12/21/2015 14:06:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTEXT_SPK0]  @parm1 varchar (4)   as
select * from PJTEXT
where  msg_num  =  @parm1
order by    msg_num
GO
