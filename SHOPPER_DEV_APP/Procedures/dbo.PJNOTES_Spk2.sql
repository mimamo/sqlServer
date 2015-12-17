USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJNOTES_Spk2]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJNOTES_Spk2] @parm1 varchar (4) , @parm2 varchar (64) , @parm3 varchar (2)  as
SELECT * from PJNOTES
WHERE   note_type_cd =  @parm1 and
        key_value = @parm2 and
        key_index = @parm3
ORDER BY
        note_type_cd,
        key_value,
        key_index
GO
