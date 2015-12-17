USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBDET_SALL2]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBDET_SALL2]  @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (4)   as
select * from PJSUBDET
where
PJSUBDET.project       =    @parm1 and
PJSUBDET.subcontract   =    @parm2 and
PJSUBDET.sub_line_item LIKE @parm3
order by PJSUBDET.project, PJSUBDET.subcontract, PJSUBDET.sub_line_item
GO
