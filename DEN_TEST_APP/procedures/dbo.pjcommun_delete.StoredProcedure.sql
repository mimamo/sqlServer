USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjcommun_delete]    Script Date: 12/21/2015 15:37:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[pjcommun_delete] @parm1 varchar (6) , @parm2 varchar (48) , @parm3 varchar (2), @parm4 varchar(10),@parm5 varchar(47) as 

DELETE from PJCOMMUN WHERE
   msg_type = @parm1 and
   msg_key = @parm2 and
   msg_suffix = @parm3 and
   (
 	(destination = @parm4 and destination_type = '' ) or  
   	(destination = @parm5 and destination_type = 'U') 
   )
GO
