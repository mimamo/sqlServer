USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJRULIP_spk1]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRULIP_spk1] @parm1 varchar (4) ,@parm2 varchar (16)   as
select * from PJRULIP
where bill_type_cd =  @parm1 and
PJRULIP.acct =  @parm2
order by bill_type_cd, acct
GO
