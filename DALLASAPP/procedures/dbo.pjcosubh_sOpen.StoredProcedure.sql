USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjcosubh_sOpen]    Script Date: 12/21/2015 13:44:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjcosubh_sOpen] @PARM1 varchar (16) as
select * from pjcosubh
Where
project = @PARM1 and
status1 <> 'A' and status1 <> 'C'
GO
