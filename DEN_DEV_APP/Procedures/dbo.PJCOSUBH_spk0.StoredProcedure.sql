USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJCOSUBH_spk0]    Script Date: 12/21/2015 14:06:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJCOSUBH_spk0] @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (16)  as
select * from PJCOSUBH
where
project          LIKE @parm1 and
subcontract      LIKE @parm2 and
change_order_num LIKE @parm3
order by project, subcontract, change_order_num
GO
