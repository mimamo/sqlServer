USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYHDR_Svend]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPAYHDR_Svend]  @parm1 varchar (15)   as
select * from PJPAYHDR
where
PJPAYHDR.vendid   =    @parm1 and
PJPAYHDR.status1  <> 'P'
GO
