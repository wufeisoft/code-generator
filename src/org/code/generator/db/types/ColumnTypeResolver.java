/**
 * COPYRIGHT (C) 2012 3KW. ALL RIGHTS RESERVED.
 *
 * No part of this publication may be reproduced, stored in a retrieval system,
 * or transmitted, on any form or by any means, electronic, mechanical, photocopying,
 * recording, or otherwise, without the prior written permission of 3KW.
 *
 * Created By: wufei
 * Created On: 2012-4-24
 *
 * Amendment History:
 * 
 * Amended By       Amended On      Amendment Description
 * ------------     -----------     ---------------------------------------------
 *
 **/
package org.code.generator.db.types;

import org.code.generator.db.TableColumn;

public interface ColumnTypeResolver {

	int NVARCHAR = -9;
	int NCHAR = -15;
	int NCLOB = 2011;

	public String calculateJavaType(TableColumn tableColumn);

}