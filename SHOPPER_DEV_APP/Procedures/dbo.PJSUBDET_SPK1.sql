USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJSUBDET_SPK1]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJSUBDET_SPK1]  @parm1 varchar (16) , @parm2 varchar (16)   as
select  *       from PJSUBDET
where
PJSUBDET.project       =    @parm1 and
PJSUBDET.subcontract   =    @parm2
order by PJSUBDET.project, PJSUBDET.subcontract, PJSUBDET.sub_line_item
GO
