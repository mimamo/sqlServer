USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJBUDSUM_dpjtpln]    Script Date: 12/21/2015 15:37:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJBUDSUM_dpjtpln] @parm1 varchar (16) , @parm2 varchar (2)   as
Delete from PJBUDSUM
WHERE
project = @parm1 and
planNbr = @parm2
GO
