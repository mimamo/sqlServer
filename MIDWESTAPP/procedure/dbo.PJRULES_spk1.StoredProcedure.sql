USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJRULES_spk1]    Script Date: 12/21/2015 15:55:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJRULES_spk1] @parm1 varchar (4) , @parm2 varchar (16) , @parm3 varchar (1)   as
select * from PJRULES
where bill_type_cd = @parm1 and
acct         = @parm2 and
li_type      = @parm3
order by bill_type_cd, acct
GO
