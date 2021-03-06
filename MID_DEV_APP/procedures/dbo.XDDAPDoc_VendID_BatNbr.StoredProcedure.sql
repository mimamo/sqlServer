USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAPDoc_VendID_BatNbr]    Script Date: 12/21/2015 14:18:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDAPDoc_VendID_BatNbr] 
	@parm1 	varchar( 15 ), 
	@parm2 	varchar( 10 ) 
AS
  Select 	* 
  FROM		APDoc 
  WHERE		VendID LIKE @parm1 
  		and DocClass = 'C' 
  		and ((Rlsed = 1 and DocType = 'CK')
  			or
  		     (DocType = 'HC')			-- Allow Releaed batches to process... should give warning...
  		    )	
  		and BatNbr = @parm2 
  		and Status <> 'V'
  ORDER BY	VendID, DocClass, Rlsed, BatNbr
GO
