USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYHDR_SPK2]    Script Date: 12/21/2015 16:01:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPAYHDR_SPK2]  @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (4)   as
select * from PJPAYHDR
where
PJPAYHDR.project     LIKE    @parm1 and
PJPAYHDR.subcontract   LIKE    @parm2 and
PJPAYHDR.payreqnbr    LIKE   @parm3
	order by PJPAYHDR.project, PJPAYHDR.subcontract, PJPAYHDR.payreqnbr
GO
