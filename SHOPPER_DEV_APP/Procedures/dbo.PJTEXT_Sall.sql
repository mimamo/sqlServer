USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJTEXT_Sall]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTEXT_Sall]  @parm1 varchar (4)   as
select * from PJTEXT
where    msg_num Like  @parm1
order by   msg_num
GO
